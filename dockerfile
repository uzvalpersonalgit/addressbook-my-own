# Below line has tomcat image base along with java required
FROM tomcat:8.5.72-jdk8-openjdk-buster

# below lines from 5 to 14 are maven which are required to build, install all the phases using maven
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_VERSION 3.8.4

RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share && \
    mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# this app directory will create in the container and all the execution happens
Workdir /app    
# first copy line are from host (EC2 here) and copy it container app folder
# as these files required to run maven, jfrog
copy ./pom.xml  ./pom.xml
copy ./src      ./src
copy ./settings.xml  ./settings.xml

# this command pcakge using maven and create war file
Run mvn package
# below line will deploy to jfrog
Run mvn -U deploy -s settings.xml

# any linux commands need to run in the container, need to use RUN command like below
# below command is within the container copy from one location to another
Run cp /app/target/addressbook-my-own.war /usr/local/tomcat/webapps

Expose 8080

CMD ["catalina.sh", "run"]

