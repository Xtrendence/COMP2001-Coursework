using System;
using System.Collections.Generic;

#nullable disable

namespace Auth.Models
{
    public partial class Password
    {
        public int userId { get; set; }
        public string oldPassword { get; set; }
        public DateTime changeDate { get; set; }

        public virtual User User { get; set; }
    }
}
