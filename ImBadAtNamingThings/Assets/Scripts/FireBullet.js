private var shootRay : Ray;                                   
private var shootHit : RaycastHit;                            
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
     Instantiate(bullet,shootHit.point, Quaternion.LookRotation( shootHit.normal));
    }
}