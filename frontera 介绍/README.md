这是我做的关于 [frontera](https://github.com/scrapinghub/frontera) 的介绍。包含：

### PPT
介绍的PPT


### single_requests_spider 
使用 requests 写的单机。
运行：
`$ python links_follower.py`


### single_scrapy_spider
写的 scrapy 写的单机爬虫。参照 http://frontera.readthedocs.io/en/latest/topics/quick-start-single.html 和 http://frontera.readthedocs.io/en/latest/topics/scrapy-integration.html 。
运行：
`$ scrapy crawl quotes`


### distribute_spider
分布式爬虫。参考 http://frontera.readthedocs.io/en/latest/topics/quick-start-distributed.html 。
运行 ZeroMQ broker：
`python -m frontera.contrib.messagebus.zeromq.broker`
运行 DB worker：
`python -m frontera.worker.db --config frontier.workersettings`
运行 spider：
```
$ scrapy crawl general -L INFO -s FRONTERA_SETTINGS=frontier.spider_settings -s SEEDS_SOURCE=seeds_es_smp.txt -s SPIDER_PARTITION_ID=0
$ scrapy crawl general -L INFO -s FRONTERA_SETTINGS=frontier.spider_settings -s SPIDER_PARTITION_ID=1
```


### cluster_spider
集群爬虫。参考 http://frontera.readthedocs.io/en/latest/topics/cluster-setup.html
运行 DB worker
```
# start DB worker only for batch generation
$ python -m frontera.worker.db --config [db worker config module] --no-incoming
...
# Then start next one dedicated to spider log processing
$ python -m frontera.worker.db --no-batches --config [db worker config module]
```
运行 strategy worker
```
$ python -m frontera.worker.strategy --config [strategy worker config] --partition-id 0
$ python -m frontera.worker.strategy --config [strategy worker config] --partition-id 1
...
$ python -m frontera.worker.strategy --config [strategy worker config] --partition-id N
```
运行 spider
```
$ scrapy crawl [spider] -L INFO -s SEEDS_SOURCE = 'seeds.txt' -s SPIDER_PARTITION_ID=0
...
$ scrapy crawl [spider] -L INFO -s SPIDER_PARTITION_ID=1
$ scrapy crawl [spider] -L INFO -s SPIDER_PARTITION_ID=2
...
$ scrapy crawl [spider] -L INFO -s SPIDER_PARTITION_ID=N
```


注意：
上面 single_requests_spider、distribute_spider、cluster_spider 均来在 [frontera examples](https://github.com/scrapinghub/frontera/tree/master/examples)，分别对应 requests、general-spider、cluster。
