using System;
using System.Collections.Generic;

#nullable disable

namespace Auth.Models
{
    public partial class LoginCount
    {
        public int UserId { get; set; }
        public int? TotalLogins { get; set; }
    }
}
