using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.AspNet.Identity;


/// Class that registers user
public class UserRegister
{
    private UserStore<IdentityUser> userStore;
    private UserManager<IdentityUser> userManager;
    public UserRegister()
    {
        userStore = new UserStore<IdentityUser>();
        userManager = new UserManager<IdentityUser>(userStore);
    }
    //Register user
    public void registerUser(string username,string password)
    {
        if (userManager.Find(username, password) == null)
            userManager.Create(new IdentityUser() { UserName = username }, password);
        else
            throw new Exception("User already exists");
    }
}