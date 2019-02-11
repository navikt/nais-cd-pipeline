node { 
    def lastCommit
    
    try {
        stage("init") {
            git url: "https://github.com/navikt/nais-cd-pipeline.git"

            sh("rm -rf naisible nais-inventory nais-tpa nais-platform-apps")

            dir("nais-inventory") {
                git credentialsId: 'nais-inventory', url: "git@github.com:navikt/nais-inventory.git"
            }

            dir("naisible") {
                git url: "https://github.com/nais/naisible.git"
            }

            dir("nais-platform-apps") {
                git credentialsId: 'nais-platform-apps', url: "git@github.com:navikt/nais-platform-apps.git"
            }

            dir("nais-yaml") {
                git credentialsId: 'nais-yaml', url: "git@github.com:navikt/nais-yaml.git"
            }

            dir("nais-tpa") {
                git credentialsId: 'nais-tpa', url: "git@github.com:navikt/nais-tpa.git"
            }

            lastCommit = sh(script: "/bin/sh ./echo_last_commit.sh", returnStdout: true).trim()

            slackSend channel: '#nais-ci', message: "pipeline triggered:\n${lastCommit}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'
        }
        
        stage("deploy nais-ci") {
            build job: "nsync_nais-ci", parameters: [booleanParam(name: 'skipNaisible', value: params.skipNaisible )]
        }

        stage("deploy dev"){
            parallel (
                "dev-fss" : {
                    build job: "nsync_preprod-fss", parameters: [booleanParam(name: 'skipNaisible', value: params.skipNaisible )]
                },
                "dev-sbs" : {
                    build job: "nsync_preprod-sbs", parameters: [booleanParam(name: 'skipNaisible', value: params.skipNaisible )]
                },
/*                "dev-gcp" : {
                    def buildUrl = "https://circleci.com/gh/nais/nais-gke/"
                   try {
                        withEnv(['HTTPS_PROXY=http://webproxy-utvikler.nav.no:8088', 'NO_PROXY=adeo.no']) {
                             withCredentials([string(credentialsId: 'nais-circleci', variable: 'TOKEN')]) {
                                 // trigger circle-ci build and save the build number
                                 def buildNum = sh(script: "curl -v -X POST --header \"Content-Type: application/json\" -d '{ \"build_parameters\": { \"CLUSTER_NAME\": \"dev-gcp\", \"GCP_PROJECT_NAME\": \"nais-dev-231008\", \"CLUSTER_CONTEXT_NAME\": \"gke_nais-dev-231008_europe-north1-a_dev-gcp\" }}' https://circleci.com/api/v1.1/project/github/nais/nais-gke?circle-token=${TOKEN} | jq .build_num", returnStdout: true).trim()
                                 buildUrl += "${buildNum}"
                                 retry(15) {
                                     sleep 10
                                     // check if build is finished. Produces correct exit status (which results in a retry) by executing the output (either true or false) directly
                                     sh("\$(curl -s https://circleci.com/api/v1.1/project/github/nais/nais-gke/${buildNum}?circle-token=${TOKEN} | jq '.outcome!=null')")
                                 }
                                 // same as previous, only we now check if everything went fine. Will abort if not.
                                 sh("\$(curl -s https://circleci.com/api/v1.1/project/github/nais/nais-gke/${buildNum}?circle-token=${TOKEN} | jq '.outcome==\"success\"')")
                             }
                        }

                        // slackSend channel: '#nais-ci', color: "good", message: "dev-gke  successfully nsynced :nais: ${buildUrl}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'

                    } catch (e) {
                        // slackSend channel: '#nais-ci', color: "danger", message: ":shit: nsync of dev-gke failed: ${e.getMessage()}.\nSee log for more info ${buildUrl}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'

               		throw e
                    }
                } */
/*                "dev-gke" : {
                    def buildUrl = "https://circleci.com/gh/nais/nais-gke/"
                   try { 
                        withEnv(['HTTPS_PROXY=http://webproxy-utvikler.nav.no:8088', 'NO_PROXY=adeo.no']) {
                             withCredentials([string(credentialsId: 'nais-circleci', variable: 'TOKEN')]) {
                                 // trigger circle-ci build and save the build number
                                 def buildNum = sh(script: "curl -v -X POST --header \"Content-Type: application/json\" -d '{ \"build_parameters\": { \"CLUSTER_NAME\": \"dev-gke\", \"GCP_PROJECT_NAME\": \"nais-dev-gke\", \"CLUSTER_CONTEXT_NAME\": \"gke_nais-dev-gke_europe-north1-a_dev-gke\" }}' https://circleci.com/api/v1.1/project/github/nais/nais-gke?circle-token=${TOKEN} | jq .build_num", returnStdout: true).trim()
                                 buildUrl += "${buildNum}"
                                 retry(15) {
                                     sleep 10
                                     // check if build is finished. Produces correct exit status (which results in a retry) by executing the output (either true or false) directly
                                     sh("\$(curl -s https://circleci.com/api/v1.1/project/github/nais/nais-gke/${buildNum}?circle-token=${TOKEN} | jq '.outcome!=null')")
                                 }
                                 // same as previous, only we now check if everything went fine. Will abort if not.
                                 sh("\$(curl -s https://circleci.com/api/v1.1/project/github/nais/nais-gke/${buildNum}?circle-token=${TOKEN} | jq '.outcome==\"success\"')")
                             }
                        }
                        
                        slackSend channel: '#nais-ci', color: "good", message: "dev-gke  successfully nsynced :nais: ${buildUrl}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'

                    } catch (e) {
                        slackSend channel: '#nais-ci', color: "danger", message: ":shit: nsync of dev-gke failed: ${e.getMessage()}.\nSee log for more info ${buildUrl}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'

               		throw e
                    }
                } */
            )
        }

        stage("deploy prod") {
            parallel (
                "prod-fss": {
                    build job: "nsync_prod-fss", parameters: [booleanParam(name: 'skipNaisible', value: params.skipNaisible )]
                },
                "prod-sbs": {
                    build job: "nsync_prod-sbs", parameters: [booleanParam(name: 'skipNaisible', value: params.skipNaisible )]
                },
                "prod-gke" : {
                   def buildUrl = "https://circleci.com/gh/nais/nais-gke/"
                    try {
                        withEnv(['HTTPS_PROXY=http://webproxy-utvikler.nav.no:8088', 'NO_PROXY=adeo.no']) {
                            withCredentials([string(credentialsId: 'nais-circleci', variable: 'TOKEN')]) {
                                // trigger circle-ci build and save the build number
                                def buildNum = sh(script: "curl -v -X POST --header \"Content-Type: application/json\" -d '{ \"build_parameters\": { \"CLUSTER_NAME\": \"prod-gke\", \"GCP_PROJECT_NAME\": \"nais-prod-gke\", \"CLUSTER_CONTEXT_NAME\": \"gke_nais-prod-gke_europe-north1-a_prod-gke\" }}' https://circleci.com/api/v1.1/project/github/nais/nais-gke?circle-token=${TOKEN} | jq .build_num", returnStdout: true).trim()
                                buildUrl += "${buildNum}"
                                retry(15) {
                                   sleep 10
                                    // check if build is finished. Produces correct exit status (which results in a retry) by executing the output (either true or false) directly
                                    sh("\$(curl -s https://circleci.com/api/v1.1/project/github/nais/nais-gke/${buildNum}?circle-token=${TOKEN} | jq '.outcome!=null')")
                                }
                                // same as previous, only we now check if everything went fine. Will abort if not.
                                sh("\$(curl -s https://circleci.com/api/v1.1/project/github/nais/nais-gke/${buildNum}?circle-token=${TOKEN} | jq '.outcome==\"success\"')")
                            }
                        }

                        slackSend channel: '#nais-ci', color: "good", message: "prod-gke  successfully nsynced :nais: ${buildUrl}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'

                    } catch (e) {
                        slackSend channel: '#nais-ci', color: "danger", message: ":shit: nsync of prod-gke failed: ${e.getMessage()}.\nSee log for more info ${buildUrl}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'

                        throw e
                    }
                }
            )
        }

        slackSend color: "good", channel: '#nais-ci', message: ":nais:-cd-pipeline ran successfully :thumbsup: ${env.BUILD_URL}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'

    } catch (e) {
        slackSend color: "danger", channel: '#nais-ci', message: "nais-cd-pipeline failed: ${e.getMessage()}\n${env.BUILD_URL}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'
    }
}
