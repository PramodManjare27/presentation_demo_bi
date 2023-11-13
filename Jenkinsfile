pipeline {
    agent any
    stages {
        stage('checkout validations') {
			steps {
                echo "checkout of scm at ${WORKSPACE}" 
		          }
        }
       stage('packaging and artifactory push') {
                        steps {
                echo 'running build.sh'
                //bat 'git-bash.exe C:\\Users\\admin\\git_checkouts\\test.sh'
                bat "set PATH=C:\\Program Files\\Git\\;%PATH% && git-bash.exe C:\\Users\\admin\\git_checkouts\\test.sh ${WORKSPACE}"
                          }
        }

                
        }
    }
