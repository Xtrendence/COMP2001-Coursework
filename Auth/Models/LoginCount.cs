using System;
using System.Collections.Generic;

#nullable disable

namespace Auth.Models
{
    public partial class LoginCount
    {
        public int userId { get; set; }
        public int? totalLogins { get; set; }
    }
}
