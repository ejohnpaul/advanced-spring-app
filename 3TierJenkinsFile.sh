node{
	def mavenHome = tool name: 'maven3.9.2'
	stage('SCM clone'){
		git credentialsId: 'Git credentials', url: 'https://github.com/IamJpizzle/spring-boot-docker'
	}
	stage('MavenBuild'){
		sh "${mavenHome}/bin/mvn clean package"
	}
	stage('QualityReport'){
		//sh "${mavenHome}/bin/mvn sonar:sonar"
	}
	stage('NexusUpload'){
		//sh "${mavenHome}/bin/mvn deploy"
	}
	stage('BuildDockerImage'){
		sh "docker build -t jpizzletech/spring-boot-mongo:1 ."
	}
	stage('PushImagetoReg'){
		withCredentials([string(credentialsId: 'DockerHubCredentials', variable: 'DockerHubCredentials')]) {
    sh "docker login -u jpizzletech -p ${DockerHubCredentials}"
}
		
		sh "docker push jpizzletech/spring-boot-mongo:1"
	}
	stage('RemoveDockerImages'){
		sh 'docker rmi $( docker images -q)'
	}
	stage('DeploytoK8s'){
		sh "kubectl apply -f myspringapp.yml"
	}
}