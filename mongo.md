
```bash

# dump
export MONGO_URI='mongodb://USER:PASS@127.0.0.1:27017/bitcoin?maxPoolSize=1&ssl=false'
mongodump --uri "$MONGO_URI" --forceTableScan --collection "history"


# restore
export MONGO_URI='mongodb+srv://USER:PASS@127.0.0.1:27017/bitcoin?maxPoolSize=1&retryWrites=true&w=majority'
mongorestore --uri "${MONGO_URI}"


# connect with CLI
mongo "$MONGO_URI"

> show dbs
> db.getCollectionNames()
> use bitcoin
> show collections
> db.history.find({}).sort({"date": -1}).skip(0).limit(10).pretty({})
> db.history.find({}).sort({"date": -1}).skip(0).limit(1).pretty({})
> db.history.count({})

```
