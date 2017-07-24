<!--
# This is a part of the hdfs-site.xml which will be merged into it once we need to configure HA HDFS
# cluster with QJM. For the details, please refer to 
# http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HDFSHighAvailabilityWithQJM.html
-->
  <property>
    <name>dfs.nameservices</name>
    <value>{{nameservices}}</value>
  </property>
  <property>
    <name>dfs.ha.namenodes.{{nameservices}}</name>
    <value>{{nn1Host}},{{nn2Host}}</value>
  </property>
  <property>
    <name>dfs.namenode.rpc-address.{{nameservices}}.{{nn1Host}}</name>
    <value>{{nn1Host}}:9000</value>
  </property>
  <property>
    <name>dfs.namenode.rpc-address.{{nameservices}}.{{nn2Host}}</name>
    <value>{{nn2Host}}:9000</value>
  </property> 
  <property>
    <name>dfs.namenode.http-address.{{nameservices}}.{{nn1Host}}</name>
    <value>{{nn1Host}}:50070</value>
  </property>
  <property>
    <name>dfs.namenode.http-address.{{nameservices}}.{{nn2Host}}</name>
    <value>{{nn2Host}}:50070</value>
  </property>
  <property>
    <name>dfs.namenode.shared.edits.dir</name>
    <value>qjournal://{{JNHosts}}/{{nameservices}}</value>
  </property>
  <property>
    <name>dfs.client.failover.proxy.provider.{{nameservices}}</name>
    <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
  </property>

  
  <property>
    <name>dfs.journalnode.edits.dir</name>
    <value>{{journalEditsDir}}</value>
  </property>

  <property>
    <name>dfs.ha.automatic-failover.enabled</name>
    <value>true</value>
  </property>


  <!--The following might be in the core-site.xml-->
  <property>
    <name>dfs.ha.fencing.methods</name>
    <!--value>sshfence(root:22)</value-->
    <value>shell(/bin/true)</value>
  </property>
  <property>
    <name>dfs.ha.fencing.ssh.private-key-files</name>
    <value>{{userHome}}/.ssh/id_rsa</value>
  </property>
  <property>
    <name>dfs.ha.fencing.ssh.connect-timeout</name>
    <value>30000</value>
  </property>