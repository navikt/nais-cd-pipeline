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

            dir("nais-tpa") {
                git credentialsId: 'navikt-ci', url: "https://github.com/navikt/nais-tpa.git"
            }

            lastCommit = sh(script: "/bin/sh ./echo_last_commit.sh", returnStdout: true).trim()

            slackSend channel: '#nais-ci', message: "pipeline triggered:\n${lastCommit}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'
        }
        
        stage("deploy nais-ci") {
            build "nsync_nais-ci"
        }

        stage("deploy !prod"){
            parallel (
                "preprod-fss" : {
                    build "nsync_preprod-fss"
                },
                "preprod-sbs" : {
                    build "nsync_preprod-sbs"
                }
            )
        }

        slackSend color: "good", channel: '#nais-ci', message: ":nais:-cd-pipeline ran successfully :thumbsup: ${env.BUILD_URL}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'

    } catch (e) {
        slackSend color: "danger", channel: '#nais-ci', message: "nais-cd-pipeline failed: ${e.getMessage()}\n${env.BUILD_URL}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'
    }
}
