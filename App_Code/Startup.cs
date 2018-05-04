using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(CSC651WebSitev2.Startup))]
namespace CSC651WebSitev2
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
