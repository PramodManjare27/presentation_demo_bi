pipeline {
    agent any
	 options {
        disableConcurrentBuilds()
    }
    stages {
        stage('checkout validations') {
			steps {
                echo "checkout of scm at ${WORKSPACE}" 
			    echo "Branch name is ${BRANCH_NAME}"
				echo "Build number is ${BUILD_NUMBER}"
		        bat "set PATH=C:\\Program Files\\Git\\;%PATH% && git-bash.exe C:\\Users\\admin\\git_checkouts\\checkout_validation.sh ${WORKSPACE} ${BRANCH_NAME} ${BUILD_NUMBER}"
    				}
        }
        stage('packaging and artifactory push') {
	       when {
	            expression { BRANCH_NAME ==~ /(feature*dwh_bi_Rel_[0-9][0-9]_*|dwh_bi_Rel_[0-9][0-9]|bugfix*dwh_bi_Rel_[0-9][0-9]_*) }
	            }
           steps {
                echo 'running build.sh'
                bat "set PATH=C:\\Program Files\\Git\\;%PATH% && git-bash.exe C:\\Users\\admin\\git_checkouts\\test.sh ${WORKSPACE}"
                 }
        }

                
        }
}
