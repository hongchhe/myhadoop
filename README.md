# myhadoop
What's this project aim at
1. Quickly creating hadoop-related environment to be used
2. Quick Start about hadoop-related projects
How does this project work
1. clone this repository into your local pc
   > git clone https://github.com/hongchhe/myhadoop.git
2. change it into the desired project directory
   > cd ~/myhadoop/hadoop
## Hadoop
### Creating using docker-compose
- create standlone hadoop environment
  > docker-compose up
- create simple cluster hadoop environment
  > docker-compose -f docker-compose-cluster.yml up

## Spark
### Tasks list
- [x] create standalone Dockerfile and docker-compose
- [x] add the python related tools to be used, e.g. numpy, scipy,pandas, ipython and ipython-notebook
- [ ] provide the quick-start examples
- [ ] create complicated cluster environments
### Creating using docker-compose
## Hbase
