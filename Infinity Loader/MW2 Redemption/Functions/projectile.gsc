Projectile(projectile)
{
    self notify("EndProjectile");
    self endon("disconnect");
    self endon("EndProjectile");
    
    while(1)
    {
        self waittill("weapon_fired");
        MagicBullet(projectile+"_mp", self GetEye(), self TraceBullet(),self);
    }
}

EndProjectile()
{
    self notify("EndProjectile");
}