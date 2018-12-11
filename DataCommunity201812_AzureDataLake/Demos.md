# Demo 0

Pokazac Visual Studio Tool for ADLA 

Pokazac Project ADLA

Pokazac VS Server Explorer

# Demo 1 (Lokalnie)

Demo000IISLogs.usql - Analiza logów z serwera IIS

Powiedzieć o 

Apply scheme on-read

Push-down-predicate

Assembly+C# function

# Demo 2 (Lokalnie)

Demo002Crimes.usql

Pokazać dataset źrodłowy : d:\AppData\BIGDATA\UKCrimes\

Pokazać jak utworzyć bazę -skrypt  Init\CreateDatabase.usql

Pokazać funckję tabelaryczną skrypt Init\TVF\tvf_GetCrimes.usql

​	Pokazać IF statement oraz dwa rowset'y

# Demo 3 (Azure ADLA-25)

Demo003Stackoverflow.usql -najpierw uruchomić skrytp na Azure ADLA-25

Pokazać dataset d:\AppData\BIGDATA\StackOverFlow\programmers\Post1.xml

Pokazać dataset na Azure mySample/StackOverFlow

Generalnie będziemy starali się określić popolarność danej technologii na podstawie wpisów na stactoverflow. Dane w postaci XML.  Użyjemy procesora XmlXPathProcessor. Jak działa procesor

przykład: Demos\Samples\Processor.usql

W przypadku stackoverflow - uzyjemy aby z atrybutow stworzyc kolumny w rowsetcie (pokazać XmlXPathProcessor.cs -ADLAExt\Processors)

Pokazac skrypt do rejestracji .NET Init\RegisterExtensions.usql lub VS Register Assembly on Database

Omowic skrypt (kategorie, konwersje, statystyki)

Pokazac wykonanie na Azure 

Pokazac wynik na Azure

Pokazac i omowic ADLU Usage (over and under allocation)

# Demo 4 (Localnie)

Pokazac jak zarejestrowac Cognitive na Azure (adlademos - Sample scripts )

Pokazac skrypt do rejestacji  Init\RegisterCognitiveAssemblies.usql

Pokazac dataset d:\AppData\BIGDATA\Images\

Uruchomić skrypt -pokazac U-SQL i pokazac wyniki (generalnie face and emotion recognitiion)



# Demo 5 (ADF)

Ten sam dataset co poprzednio tylko teraz bedziemy uruchamiac procesowanie przez ADF. Lokalnie mamy dane i w pierwszym kroku skopijujemy je do chmury, nastepnie uruchomimy przetwarzanie w ADLA, wyniki zapiszemy na ADLS a nastepnie do bazy lokalnej.

SSMS->Images

```sql
USE Images;
TRUNCATE TABLE ImageObjects
```



```sql
USE Images;
SELECT * FROM ImageObjects;
```



# Demo 6 (Python -Azure ADLU=1)

Pokazac jak dziala Reducer Samples->Reducer.usql (break reducer -przerwy mniejsze niz 180 zostana zlaczone-wartości zostaną zsumowane)

Python -Python reducer Extension.Python.Reducer

Pokazac ApplyModel.py umain (df)

Pokaza Depoy DEPLOY RESOURCE

Pokazac Resources -Job View -Resources



Demo 7 (ADLU INfo)

Pokazac EXPIRATION @expiry