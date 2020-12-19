
using Microsoft.AspNetCore.Identity;
using System;


namespace skoll.Dominio.Common
{
    public class ApplicationUser : IdentityUser
    {
        public DateTime CreatedDate { get; set; }
        public DateTime LastModifiedDate { get; set; }
    }
}
