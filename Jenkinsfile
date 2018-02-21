pipeline {
    agent any
    stages {
        stage("init") {
            steps {
                git credentialsId: 'navikt-ci', url: "https://github.com/navikt/nais-cd-pipeline.git"
            }
        }
        
        stage("deploy nais-ci") {
            steps {
                build "deploy_nais-ci"
            }
        }

        stage("deploy !prod"){
            steps {
                parallel (
                    "nais-dev" : {
                        build "deploy_nais-dev"
                    },
                    "nais-ci" : {
                        build "deploy_nais-ci"
                    }
                )
            }
        }
    }
}
