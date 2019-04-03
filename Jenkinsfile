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
                }
            )
        }

        stage("deploy prod") {
            parallel (
                "prod-fss": {
                    build job: "nsync_prod-fss", parameters: [booleanParam(name: 'skipNaisible', value: params.skipNaisible )]
                },
                "prod-sbs": {
                    build job: "nsync_prod-sbs", parameters: [booleanParam(name: 'skipNaisible', value: params.skipNaisible )]
                }
            )
        }

        slackSend color: "good", channel: '#nais-ci', message: ":nais:-cd-pipeline ran successfully :thumbsup: ${env.BUILD_URL}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'

    } catch (e) {
        slackSend color: "danger", channel: '#nais-ci', message: "nais-cd-pipeline failed: ${e.getMessage()}\n${env.BUILD_URL}", teamDomain: 'nav-it', tokenCredentialId: 'slack_fasit_frontend'
    }
}
