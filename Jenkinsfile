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
                build "nsync_nais-ci"
            }
        }

        stage("deploy !prod"){
            steps {
                parallel (
                    "nais-dev" : {
                        build "nsync_nais-dev"
                    },
                    "nais-ci" : {
                        build "nsync_nais-ci"
                    }
                )
            }
        }
    }
}
