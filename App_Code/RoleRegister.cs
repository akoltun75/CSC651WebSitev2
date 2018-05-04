using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity;
/// Utitily class for registering roles
public class RoleRegister
{
    private RoleStore<IdentityRole> roleStore;
    private RoleManager<IdentityRole> roleManager;
    public RoleRegister()
    {
        roleStore = new RoleStore<IdentityRole>();
        roleManager = new RoleManager<IdentityRole>(roleStore);
    }
    //Register role
    public void createRole(string rolename)
    {
        if (!roleManager.RoleExists(rolename))
            roleManager.Create(new IdentityRole(rolename));
        else
            throw new Exception("Role already exists");
    }
    //Assigns role to given user
    public void assignRole(string username, string rolename)
    {
      var userManager = new UserManager<IdentityUser>(new UserStore<IdentityUser>());
        var user = userManager.FindByName(username);
        if (roleManager.RoleExists(rolename)&&user!=null)
        {
            userManager.AddToRole(user.Id, rolename);
        }
        
}
}