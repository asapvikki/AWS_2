# Default region needs to be set using aws configure command to run this script

# Getting VPC ID
vpcID=`aws ec2 create-vpc --cidr-block 10.0.1.0/24 | jq '.Vpc.VpcId'`

#Removing Quotes
vpcID=`sed -e 's/^"//' -e 's/"$//' <<<"$vpc_id"`
echo $vpcID

# Creating subnets in different availablity zones, both public subnets and private subnets
pvtsubA=`aws ec2 create-subnet --availability-zone us-east-1a --vpc-id $vpcID --cidr-block 10.0.1.0/28 | jq '.Subnet.SubnetId'`
pubsubA=`aws ec2 create-subnet --availability-zone us-east-1a --vpc-id $vpcID --cidr-block 10.0.1.16/28 | jq '.Subnet.SubnetId'`
pubsubA=`sed -e 's/^"//' -e 's/"$//' <<<"$pubsubA"`
pvtsubA=`sed -e 's/^"//' -e 's/"$//' <<<"$pvtsubA"`


pvtsubB=`aws ec2 create-subnet --availability-zone us-east-1b --vpc-id $vpcID --cidr-block 10.0.1.32/28 | jq '.Subnet.SubnetId'`
pubsubB=`aws ec2 create-subnet --availability-zone us-east-1b --vpc-id $vpcID --cidr-block 10.0.1.48/28 | jq '.Subnet.SubnetId'`
pubsubB=`sed -e 's/^"//' -e 's/"$//' <<<"$pubsubB"`
pvtsubB=`sed -e 's/^"//' -e 's/"$//' <<<"$pvtsubB"`


pvtsubC=`aws ec2 create-subnet --availability-zone us-east-1c --vpc-id $vpcID --cidr-block 10.0.1.64/28 | jq '.Subnet.SubnetId'`
pubsubC=`aws ec2 create-subnet --availability-zone us-east-1c --vpc-id $vpcID --cidr-block 10.0.1.80/28 | jq '.Subnet.SubnetId'`
pubsubC=`sed -e 's/^"//' -e 's/"$//' <<<"$pubsubC"`
pvtsubC=`sed -e 's/^"//' -e 's/"$//' <<<"$pvtsubC"`


# Creating Internet Gateway
igwID=`aws ec2 create-internet-gateway | jq '.InternetGateway.InternetGatewayId'`
igwID=`sed -e 's/^"//' -e 's/"$//' <<<"$igwID"`


# Attaching Internet Gateway to the VPC
temp1=`aws ec2 attach-internet-gateway --vpc-id $vpcID --internet-gateway-id $igwID`

# Creating route table one for public and one for private
rtb_pub=`aws ec2 create-route-table --vpc-id $vpcID | jq '.RouteTable.RouteTableId'`
rtb_pvt=`aws ec2 create-route-table --vpc-id $vpcID | jq '.RouteTable.RouteTableId'`
rtb_pub=`sed -e 's/^"//' -e 's/"$//' <<<"$rtb_pub"`
rtb_pvt=`sed -e 's/^"//' -e 's/"$//' <<<"$rtb_pvt"`

# Attaching route table with the internet gateway
temp2=`aws ec2 create-route --route-table-id $rtb_pub --destination-cidr-block 0.0.0.0/0 --gateway-id $igwID`


# Attaching public subnets to public route table and private subnet to private route table
assoc_id_pub_a=`aws ec2 associate-route-table  --subnet-id $pubsubA --route-table-id $rtb_pub | jq '.AssociationId'`
assoc_id_pub_b=`aws ec2 associate-route-table  --subnet-id $pubsubB --route-table-id $rtb_pub | jq '.AssociationId'`
assoc_id_pub_c=`aws ec2 associate-route-table  --subnet-id $pubsubC --route-table-id $rtb_pub | jq '.AssociationId'`

assoc_id_pvt_a=`aws ec2 associate-route-table  --subnet-id $pvtsubA --route-table-id $rtb_pvt | jq '.AssociationId'`
assoc_id_pvt_b=`aws ec2 associate-route-table  --subnet-id $pvtsubB --route-table-id $rtb_pvt | jq '.AssociationId'`
assoc_id_pvt_c=`aws ec2 associate-route-table  --subnet-id $pvtsubC --route-table-id $rtb_pvt | jq '.AssociationId'`
