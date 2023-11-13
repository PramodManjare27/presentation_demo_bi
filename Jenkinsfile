pipeline {
    agent any
    stages {
        stage('checkout') {
			steps {
                echo 'checkout of scm'
		          }
        }
       stage('packaging') {
                        steps {
                echo 'running build.sh'
                bat 'git-bash.exe C:\\Users\\admin\\git_checkouts\\test.sh'
                          }
        }

                
        }
    }
