node {

    def lastCommit
    
    try {
        stage("init") {
            git credentialsId: 'navikt-ci', url: "https://github.com/navikt/nais-cd-pipeline.git"

            sh("rm -rf naisible nais-inventory nais-tpa nais-platform-apps")

            dir("nais-inventory") {
                git credentialsId: 'navikt-ci', url: "https://github.com/navikt/nais-inventory.git"
            }

            dir("naisible") {
                git url: "https://github.com/nais/naisible.git"
            }

            dir("nais-platform-apps") {
                git credentialsId: 'navikt-ci', url: "https://github.com/navikt/nais-platform-apps.git"
            }

            dir("nais-yaml") {
                git credentialsId: 'navikt-ci', url: "https://github.com/navikt/nais-yaml.git"
            }

            dir("nais-tpa") {
                git credentialsId: 'navikt-ci', url: "https://github.com/navikt/nais-tpa.git"
            }

            lastCommit = sh(script: "/bin/sh ./echo_last_commit.sh", returnStdout: true).trim()

            slackSend channel: '#nais-ci', message: "pipeline triggered:\n${lastCommit}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'
        }
        
        stage("deploy nais-ci") {
            build "nsync_nais-ci"
        }

        stage("deploy dev"){
            parallel (
                "dev-fss" : {
                    build "nsync_preprod-fss"
                },
                "dev-sbs" : {
                    build "nsync_preprod-sbs"
                },
                "dev-gke" : {
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
                } 
            )
        }

        stage("deploy prod") {
            parallell(
                "prod-fss": {
                    build "nsync_prod-fss"
                },
                "prod-sbs": {
                    build "nsync-prod-sbs"
                }
            )
        }

        slackSend color: "good", channel: '#nais-ci', message: ":nais:-cd-pipeline ran successfully :thumbsup: ${env.BUILD_URL}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'

    } catch (e) {
        slackSend color: "danger", channel: '#nais-ci', message: "nais-cd-pipeline failed: ${e.getMessage()}\n${env.BUILD_URL}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'
    }
}
