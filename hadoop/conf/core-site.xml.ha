
  <property>
    <name>ha.zookeeper.quorum</name>
    <!--value>zk1:2181,zk2:2181,zk3:2181</value-->
    <value>{{ZKHosts}}</value>
  </property>

  <property>
    <name>dfs.ha.fencing.methods</name>
    <value>sshfence</value>
  </property>
  <property>
    <name>dfs.ha.fencing.ssh.private-key-files</name>
    <value>{{userHome}}/.ssh/id_rsa</value>
  </property>
