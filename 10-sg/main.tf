module "sg" {
    count = length(var.sg_names)
    source = "git::https://github.com/VinayMukkisa/terraform-aws-sg.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = var.sg_names[count.index]
    sg_description = "Created for ${var.sg_names[count.index]} servers"
    vpc_id =  local.vpc_id
}
