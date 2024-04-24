const { Client } = require('pg'); // Für PostgreSQL
// const mysql = require('mysql'); // Für MySQL

// Konfiguration für die Datenbankverbindung
const dbConfig = {
  user: 'postgres',
  password: 'webapp',
  host: 'localhost', // Ändere den Host entsprechend deiner Datenbank
  port: 5432, // Portnummer (z. B. 5432 für PostgreSQL, 3306 für MySQL)
  database: 'test_webapp_db', // Name deiner Datenbank
};

// Erstelle eine neue Verbindung
const client = new Client(dbConfig);

// Verbinde mit der Datenbank
client.connect()
  .then(() => {
    console.log('Verbindung zur Datenbank erfolgreich!');
    // Hier kannst du weitere Aktionen ausführen, z. B. Abfragen durchführen
    // client.query('SELECT * FROM meine_tabelle')
    //   .then(result => console.log('Ergebnis:', result.rows))
    //   .catch(error => console.error('Fehler bei der Abfrage:', error));
  })
  .catch(error => {
    console.error('Fehler beim Verbinden mit der Datenbank:', error);
  })
  .finally(() => {
    // Schließe die Verbindung
    client.end();
  });
