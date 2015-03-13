private var shootRay : Ray;                                   
private var shootHit : RaycastHit; 
var player :Transform;                           
var bullet :Transform;
var hitDistance =50.0;
var shellFalls : AudioClip;                    
function Update ()
{
   
    if(Input.GetMouseButtonDown(0))
    {
        // ... shoot the gun.
        Shoot ();
       // audio.PlayOneShot(shellFalls,0.7);
            }
}



public function Shoot ()
{
    if(Physics.Raycast (transform.position, transform.forward, shootHit,hitDistance))
    {
     
     var enemyHealth  = shootHit.collider.GetComponent (BulletEffect);
      if(enemyHealth != null)
        {   
            // ... the enemy should take damage.
            enemyHealth.TakeDamage ();
        }
        else
          {
           Instantiate(bullet,shootHit.point+(player.position-shootHit.point)*0.01 , Quaternion.LookRotation( shootHit.normal));
           
           }

}}