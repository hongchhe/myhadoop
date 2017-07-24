
  <property>
    <name>ha.zookeeper.quorum</name>
    <value>{{ZKHosts}}</value>
  </property>

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