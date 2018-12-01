namespace SweetsMachineSimulatorApp
{
    partial class Main
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.button1 = new System.Windows.Forms.Button();
            this.btnStop = new System.Windows.Forms.Button();
            this.panel1 = new System.Windows.Forms.Panel();
            this.rtbTemp = new System.Windows.Forms.RichTextBox();
            this.rtbLog = new System.Windows.Forms.RichTextBox();
            this.btnLoad = new System.Windows.Forms.Button();
            this.rbSendToCloud = new System.Windows.Forms.RadioButton();
            this.panel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(35, 35);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(166, 42);
            this.button1.TabIndex = 0;
            this.button1.Text = "Start";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // btnStop
            // 
            this.btnStop.Location = new System.Drawing.Point(247, 35);
            this.btnStop.Name = "btnStop";
            this.btnStop.Size = new System.Drawing.Size(166, 42);
            this.btnStop.TabIndex = 1;
            this.btnStop.Text = "Stop";
            this.btnStop.UseVisualStyleBackColor = true;
            this.btnStop.Click += new System.EventHandler(this.btnStop_Click);
            // 
            // panel1
            // 
            this.panel1.Controls.Add(this.rtbTemp);
            this.panel1.Controls.Add(this.rtbLog);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panel1.Location = new System.Drawing.Point(0, 158);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(688, 708);
            this.panel1.TabIndex = 2;
            // 
            // rtbTemp
            // 
            this.rtbTemp.Location = new System.Drawing.Point(12, 288);
            this.rtbTemp.Name = "rtbTemp";
            this.rtbTemp.ReadOnly = true;
            this.rtbTemp.Size = new System.Drawing.Size(661, 393);
            this.rtbTemp.TabIndex = 1;
            this.rtbTemp.Text = "";
            // 
            // rtbLog
            // 
            this.rtbLog.Location = new System.Drawing.Point(12, 34);
            this.rtbLog.Name = "rtbLog";
            this.rtbLog.ReadOnly = true;
            this.rtbLog.Size = new System.Drawing.Size(661, 221);
            this.rtbLog.TabIndex = 0;
            this.rtbLog.Text = "";
            // 
            // btnLoad
            // 
            this.btnLoad.Location = new System.Drawing.Point(441, 35);
            this.btnLoad.Name = "btnLoad";
            this.btnLoad.Size = new System.Drawing.Size(166, 42);
            this.btnLoad.TabIndex = 3;
            this.btnLoad.Text = "Load Products";
            this.btnLoad.UseVisualStyleBackColor = true;
            this.btnLoad.Click += new System.EventHandler(this.btnLoad_Click);
            // 
            // rbSendToCloud
            // 
            this.rbSendToCloud.AutoSize = true;
            this.rbSendToCloud.Location = new System.Drawing.Point(45, 108);
            this.rbSendToCloud.Name = "rbSendToCloud";
            this.rbSendToCloud.Size = new System.Drawing.Size(118, 21);
            this.rbSendToCloud.TabIndex = 4;
            this.rbSendToCloud.TabStop = true;
            this.rbSendToCloud.Text = "Send to Cloud";
            this.rbSendToCloud.UseVisualStyleBackColor = true;
            // 
            // Main
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(688, 866);
            this.Controls.Add(this.rbSendToCloud);
            this.Controls.Add(this.btnLoad);
            this.Controls.Add(this.panel1);
            this.Controls.Add(this.btnStop);
            this.Controls.Add(this.button1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "Main";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "SweetsMachineSimulatorApp";
            this.panel1.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button btnStop;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.RichTextBox rtbLog;
        private System.Windows.Forms.RichTextBox rtbTemp;
        private System.Windows.Forms.Button btnLoad;
        private System.Windows.Forms.RadioButton rbSendToCloud;
    }
}

