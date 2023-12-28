const { MongoClient, ServerApiVersion } = require('mongodb');

class DatabaseClient {
    _client;

    constructor ({ uri }) {
        if (!uri) {
            throw new Error('Missing database uri!');
        }

        this._client = new MongoClient(uri, {
            serverApi: {
                version: ServerApiVersion.v1,
                strict: true,
                deprecationErrors: true,
            }
        });
    }

    async init() {
        try {
            await this._client.connect();    
            console.log('Sucessfully connected to database!');
        } catch (error) {
            console.error(`Could not connect to the database: ${JSON.stringify(error)}`);
            throw error;
        } finally {
            this._client.close();
        }
    }

    client() {
        return this._client.db('test_db');
    }
}

const databaseClient = new DatabaseClient({ uri: process.env.DATABASE_URI });

module.exports = { databaseClient };


