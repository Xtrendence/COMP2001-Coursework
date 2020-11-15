using System;
using System.Collections.Generic;

#nullable disable

namespace Auth.Models
{
    public partial class Session
    {
        public int UserId { get; set; }
        public DateTime IssueDate { get; set; }

        public virtual User User { get; set; }
    }
}
