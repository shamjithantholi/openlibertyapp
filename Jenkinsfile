def readpom
def ver
pipeline {
   
    agent any
        
    stages {
       stage('Build') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'sham-PAT', url: 'https://github.ibm.com/shamjith-antholi/openapp.git']]])
                script {
                    readpom = readMavenPom file: '';
                    ver = readpom.version;
                }
                
               configFileProvider([configFile('settings1')]) {
                   withCredentials([string(credentialsId: 'artifactory1', variable: 'pass')]) {
                        sh '''
                            mvn -U package
                            curl -H "X-JFrog-Art-Api:${pass}" -X PUT 'https://na.artifactory.swg-devops.com/artifactory/wasliberty-open-liberty/devops/guide-getting-started-main.war' -T target/guide-getting-started.war
                        '''   
                    }
                               
                }
            }
        }
         stage("next build"){
            steps {
                sh 'ls -l ./target/'
                echo "version .... ${ver}";    
                build job: 'DockerImageBuild', parameters: [string(name: 'version', value: "${ver}"), string(name: 'branch', value: 'main')]
            }
        }
        
        
    }
}
