# not yet finished

# Elasticsearch ORM

```
model = ElasticORM::Model.new
  .where(date: Date.today..Date.yesterday)
  .where(id: 1)
  .where(user_id: [1,2,3])
  .where.not(id: 9)
  .where(deleted_at: nil)

puts JSON.pretty_generate(model.to_query)
```

```
{
  "bool": {
    "filter": [
      {
        "range": {
          "date": {
            "gte": "2017-06-12",
            "lte": "2017-06-11"
          }
        }
      },
      {
        "term": {
          "id": 1
        }
      },
      {
        "bool": {
          "filter": {
            "terms": {
              "user_id": [
                1,
                2,
                3
              ]
            }
          }
        }
      },
      {
        "bool": {
          "must_not": {
            "term": {
              "id": 9
            }
          }
        }
      },
      {
        "bool": {
          "must_not": {
            "exists": {
              "field": "deleted_at"
            }
          }
        }
      }
    ]
  }
}
```