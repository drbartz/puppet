find /var/lib/puppet/ssl/ca/signed -type f -name '*.pem' | awk -F \/ '{print $NF}' | sed 's/.pem//' | grep -v puppet | while read Cert
do 
	puppet cert clean $Cert
done
