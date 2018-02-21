node {
    try {
        stage("init") {
            git credentialsId: 'navikt-ci', url: "https://github.com/navikt/nais-cd-pipeline.git"
        }
        
        stage("deploy nais-ci") {
            build "nsync_nais-ci"
        }

        stage("deploy !prod"){
            parallel (
                "nais-dev" : {
                    build "nsync_nais-dev"
                },
                "nais-ci" : {
                    build "nsync_nais-ci"
                }
            )
        }
    } catch (e) {
        echo "nooooo" 
        //slackSend channel: '#nais-internal', message: ":shit: nsync of ${clusterName} by Mr. ${env.BUILD_USER} failed: ${e.getMessage()}. ${lastCommit}\nSee log for more info ${env.BUILD_URL}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'
    }
}
//pipeline {
//    agent any
//    stages {
//        stage("init") {
//            steps {
//                git credentialsId: 'navikt-ci', url: "https://github.com/navikt/nais-cd-pipeline.git"
//            }
//        }
//        
//        stage("deploy nais-ci") {
//            steps {
//                build "nsync_nais-ci"
//            }
//        }
//
//        stage("deploy !prod"){
//            steps {
//                parallel (
//                    "nais-dev" : {
//                        build "nsync_nais-dev"
//                    },
//                    "nais-ci" : {
//                        build "nsync_nais-ci"
//                    }
//                )
//            }
//        }
//    }
//}
