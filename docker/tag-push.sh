while read line; 
do
        echo "image: ${line}";
        imageName=$(echo $line |awk '{print $1}')
        imageTag=$(echo $line |awk '{print $2}')
        imageTarName=$(echo $imageName|awk -F/ '{print $NF}')
        docker tag ${imageName}:${imageTag} 33.0.0.58:32000/library/goharbor/${imageTarName}:${imageTag}
	docker push 33.0.0.58:32000/library/goharbor/${imageTarName}:${imageTag}
done <<< "$(docker images|grep v2.5.5)"



while read line; 
do
	ssh ccse@${line} "sudo mkdir -p /data/harbor/trivy/trivy/db /data/harbor/trivy/reports; sudo chmod -R 777 /data/harbor/trivy"
	
	scp trivy-db.tar.gz ccse@33.0.0.9:/tmp/
	
	ssh ccse@33.0.0.8 'sudo tar -zxvf /tmp/trivy-db.tar.gz -C /data/harbor/trivy/trivy/db/'
done <<< "$(kubectl get no|grep -v NAME|awk '{print $1}')"