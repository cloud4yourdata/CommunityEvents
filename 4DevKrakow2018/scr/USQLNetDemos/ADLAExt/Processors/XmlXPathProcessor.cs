using Microsoft.Analytics.Interfaces;
using Microsoft.Analytics.Types.Sql;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;

namespace ADLAExt.Processors
{
    public class XmlXPathProcessor : IProcessor
    {
        private readonly string _xPathQuery;
        private readonly SqlMap<string, string> _columnPaths;

        public XmlXPathProcessor(string xPathQuery, SqlMap<string, string> columnPaths)
        {
            _xPathQuery = xPathQuery;
            _columnPaths = columnPaths;
        }
        public override IRow Process(IRow input, IUpdatableRow output)
        {
            var list = new List<string>();
            ValidateOutputSchema(output);
            string xmlContent = input.Get<string>("content");
            try
            {
                var xmlDocument = new XmlDocument();
                xmlDocument.LoadXml(xmlContent.TrimStart().TrimEnd());
                var nodeList = xmlDocument.DocumentElement.SelectNodes(_xPathQuery);
                foreach (XmlNode current in nodeList)
                {
                    XmlNodeType nodeType = current.NodeType;
                    if (nodeType != XmlNodeType.Element)
                    {
                        if (nodeType != XmlNodeType.Attribute)
                        {
                            if (IsOnColumnList(current.Name))
                            {
                                list.Add(current.Name);
                                output.Set<string>(GetColumnName(current.Name), current.InnerText);
                            }
                        }
                        else
                        {
                            XmlAttribute xmlAttribute = (XmlAttribute)current;
                            if (IsOnColumnList(xmlAttribute.Name))
                            {
                                list.Add(xmlAttribute.Name);
                                output.Set<string>(GetColumnName(xmlAttribute.Name), xmlAttribute.Value);
                            }
                        }
                    }
                    else
                    {
                        if (IsOnColumnList(current.Name))
                        {
                            list.Add(current.Name);
                            output.Set<string>(GetColumnName(current.Name), current.InnerText);
                        }
                        XmlElement xmlElement = (XmlElement)current;
                        bool hasAttributes = xmlElement.HasAttributes;
                        if (hasAttributes)
                        {
                            foreach (XmlAttribute att in xmlElement.Attributes)
                            {
                                if (IsOnColumnList(att.Name))
                                {
                                    list.Add(att.Name);
                                    output.Set<string>(GetColumnName(att.Name), att.Value);
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception)
            {
            }
            var emptyColumnList = _columnPaths.Keys.ToList().Except(list);
            if (emptyColumnList.Any())
            {
                foreach (var empty in emptyColumnList)
                {
                    output.Set<string>(GetColumnName(empty), string.Empty);
                }
            }
            list.Clear();
            return output.AsReadOnly();
        }

        private static void ValidateOutputSchema(IUpdatableRow output)
        {
            IColumn column = output.Schema.FirstOrDefault(col => col.Type != typeof(string));
            if (column != null)
            {
                throw new ArgumentException(string.Format("Column '{0}' must be of type 'string', not '{1}'", column.Name, column.Type.Name));
            }
        }

        private bool IsOnColumnList(string name)
        {
            return _columnPaths.ContainsKey(name);
        }

        private string GetColumnName(string name)
        {
            return _columnPaths[name];
        }
    }
}