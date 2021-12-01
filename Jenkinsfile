pipeline {
    agent any
    stages {
        stage('Initialize') {
            steps {
                //Check if system updated
                // sh 'apt-get update -y'

                //Ensure docker exists
                sh 'which docker-compose || curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose'

                //Ensure docker compose is executable
                sh 'chmod +x /usr/local/bin/docker-compose'  

                //For static code analysis setup
                sh 'apt-get install -y python3-pip'
                sh 'pip install -r requirements.txt'
            }
        }
        stage('OWASP Dependency Check') {
			steps {
				dependencyCheck additionalArguments: '--disableAssembly --enableExperimental --format HTML --format XML', odcInstallation: 'Default'
            }
		}
        stage('Build Test-Env') {
            steps {
                echo 'Building Environment'
                sh 'docker network create selenium_network || echo selenium_network exists'
                sh 'docker-compose -f docker-compose.yml -f docker-compose.test.yml -f docker-compose.selenium.yml down'
                sh 'docker-compose -f docker-compose.yml -f docker-compose.test.yml -f docker-compose.selenium.yml up --build -d'
                 sh 'docker-compose ps'
		input message: 'Finished using the web site? (Click "Proceed" to continue)'
            }
        }
        stage('Static Code Analyis') {
            steps {
                echo 'Analyzing code'
                // Generate pylint warning report
                sh 'pylint *.py > reports/pylint.report | echo 1'
                // sh 'docker-compose exec -T flask-app sh -c "python3 -m bandit -r ."'
            }
        }
        stage('Teardown test environment') {
            steps {
                sh 'docker-compose -f docker-compose.yml -f docker-compose.test.yml -f docker-compose.selenium.yml down'
                sh 'docker system prune -f' // prune all dangling images -f for no confirmation
            }
        }
        
    }
    post {
	success {
		dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            // Next Generation Warning plugin
            recordIssues(
                     tool: pyLint(pattern: '**/pylint.report'),
                     unstableTotalAll: 20,
                     failedTotalAll: 30
                 )
            // SonarQube
            // recordIssues enabledForFailure: true, tool: sonarQube()
		}
	}
}
