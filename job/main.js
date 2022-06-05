const AWS = require('aws-sdk');
const moment = require('moment');
const { MongoClient } = require('mongodb');

const mongoUri = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017/?maxPoolSize=1';
const mongoDatabase = process.env.MONGO_DATABASE || 'bitcoinv2';
const accessKeyId = process.env.AWS_ACCESS_KEY_ID;
const secretAccessKey = process.env.AWS_SECRET_ACCESS_KEY;
const region = process.env.AWS_REGION || 'sa-east-1';
const s3BucketName = process.env.S3_BUCKET_NAME;

AWS.config.update({ accessKeyId, secretAccessKey, region });

const persistCurrency = async (mongoClient, database, doc) => {
  const db = mongoClient.db(database);
  const collection = db.collection('history');
  try {
    const result = await collection.insertOne(doc);
    console.log(`[INFO] Document inserted with _id: ${result.insertedId}`);
  } catch (err) {
    console.error(err);
  }
}

const retrieveS3ObjectByDate = async (s3Client, s3BucketName, today) => {
  const year = today.format('YYYY');
  const month = today.format('MM');
  const day = today.format('DD');
  const s3Key = `bitcoin/year=${year}/month=${month}/day=${day}/last.json`;
  const s3GetParams = {
    Bucket: s3BucketName,
    Key: s3Key,
  };
  console.info('[INFO] s3GetParams', s3GetParams);
  try {
    const response = await s3Client.getObject(s3GetParams).promise();
    const body = response.Body.toString('utf-8');
    return JSON.parse(body);
  } catch (err) {
    console.error(err);
    throw err;
  }
}

(async () => {
  const mongoClient = new MongoClient(mongoUri);
  await mongoClient.connect();
  const s3Client = new AWS.S3({ apiVersion: '2013-04-01' });
  const today = moment();
  const content = await retrieveS3ObjectByDate(s3Client, s3BucketName, today);
  console.log('content', content);
  await persistCurrency(mongoClient, mongoDatabase, content);
  mongoClient.close();
})();
