using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

#nullable disable

namespace Auth.Models
{
    public partial class COMP2001_KNouchinContext : DbContext
    {
        public COMP2001_KNouchinContext()
        {
        }

        public COMP2001_KNouchinContext(DbContextOptions<COMP2001_KNouchinContext> options)
            : base(options)
        {
        }

        public virtual DbSet<LoginCount> LoginCounts { get; set; }
        public virtual DbSet<Password> Passwords { get; set; }
        public virtual DbSet<Session> Sessions { get; set; }
        public virtual DbSet<User> Users { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer("Server=socem1.uopnet.plymouth.ac.uk;Database=COMP2001_KNouchin;User Id=KNouchin; Password=***REMOVED***");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<LoginCount>(entity =>
            {
                entity.HasNoKey();

                entity.ToView("LoginCount");

                entity.Property(e => e.totalLogins).HasColumnName("Total Logins");

                entity.Property(e => e.userId).HasColumnName("userID");
            });

            modelBuilder.Entity<Password>(entity =>
            {
                entity.HasNoKey();

                entity.Property(e => e.changeDate).HasColumnType("datetime");

                entity.Property(e => e.oldPassword)
                    .IsRequired()
                    .HasMaxLength(255);

                entity.Property(e => e.userId).HasColumnName("userID");

                entity.HasOne(d => d.User)
                    .WithMany()
                    .HasForeignKey(d => d.userId)
                    .HasConstraintName("FK__Passwords__UserI__02084FDA");
            });

            modelBuilder.Entity<Session>(entity =>
            {
                entity.HasNoKey();

                entity.Property(e => e.issueDate).HasColumnType("datetime");

                entity.Property(e => e.userId).HasColumnName("userID");

                entity.HasOne(d => d.User)
                    .WithMany()
                    .HasForeignKey(d => d.userId)
                    .HasConstraintName("FK__Sessions__UserID__03F0984C");
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.HasIndex(e => e.email, "UQ__Users__A9D10534FB7AC94E")
                    .IsUnique();

                entity.Property(e => e.userId).HasColumnName("userID");

                entity.Property(e => e.email)
                    .IsRequired()
                    .HasMaxLength(320);

                entity.Property(e => e.firstName)
                    .IsRequired()
                    .HasMaxLength(64)
                    .IsUnicode(false);

                entity.Property(e => e.lastName)
                    .IsRequired()
                    .HasMaxLength(64)
                    .IsUnicode(false);

                entity.Property(e => e.password)
                    .IsRequired()
                    .HasMaxLength(255);
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
