# create array of variables in template files
create_variables (){
    VARIABLES+=(
    project         
    region         
    zone        
    bucket
    prefix
    environment
    credentials
    namespace           
    deployment_name     
    deployment_port     
    vof_tracker_image   
    database_name       
    database_user       
    pgpassword
    db_password      
    database_tier       
    database_version    
    db_instance_name
    vof_domain_name
    regional_static_ip
    vof_domain_name
    machine_type
    )
}
create_variables
