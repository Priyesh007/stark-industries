pipeline {
    agent { label "agentfarm" }
    stages {
      stage('Delete the workspace') {
           steps {
               cleanWs()
           }
       }
       stage('Installing Chef Workstation') {
               steps {
                 script {
                    def exists = fileExists '/user/bin/chef-client'
                    if (exists == true) {
                        echo "Skipping Chef Workstation install - already installed"
                    } else {
                       sh 'sudo apt-get install -y wget tree unzip'
                       sh 'wget https://packages.chef.io/files/stable/chef-workstation/20.10.168/ubuntu/20.04/chef-workstation_20.10.168-1_amd64.deb'
                       sh 'sudo dpkg -i chef-workstation_20.10.168-1_amd64.deb'
                       sh 'sudo chef env --chef-license accept'
                  }
               }
            }
          }
          stage('Download Apache Cookbook') {
                   steps {
                       git credentialsId: 'git-repo-creds', url: 'git@github.com:Priyesh007/apache.git'
               }
           }
           stage('Install kitchen Docker Gem') {
                  steps {
                    sh 'sudo apt-get install -y make gcc'
                    sh 'sudo chef gem install kitchen-docker'
              }
          }

          stage('Run Kitchen Destroy') {
               steps {
                sh 'sudo kitchen destroy'
                }
            }
          stage('Run Kitchen create') {
               steps {
                sh 'sudo kitchen create'
                }
            }
          stage('Run Kitchen Converge') {
               steps {
                sh 'sudo kitchen converge'
                }
            }
          stage('Run Kitchen Verify') {
               steps {
                sh 'sudo kitchen verify'
                }
            }
          stage('Kitchen Destroy') {
               steps {
                sh 'sudo kitchen destroy'
                }
          }

          stage('upload to chef server, converge nodes') {
             steps {
               withCredentials([zip(credentialsId: 'chef-starter-zip', variable: 'CHEFREPO')]) {
                  sh "chef install $WORKSPACE/Policyfile.rb -c $CHEFREPO/chef-repo/.chef/config.rb"
                  sh "chef push prod $WORKSPACE/Policyfile.lock.json -c $CHEFREPO/chef-repo/.chef/config.rb"
                }
             }
        }
           stage('Send Slack Notification') {
                steps {
                     slackSend color: 'warning', message: "Mr. Priyesh: Please approve ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.JOB_URL} | Open>)"
                }
        }
            stage('Request Input') {
                steps {
                    input 'Please approve or deny this build'
              }
        }
    }

}

