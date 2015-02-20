private var shootRay : Ray;                                   
private var shootHit : RaycastHit;                            
var bullet :Transform;                                       
function Update ()
{
   
    if(Input.GetMouseButtonDown(0))
    {
        // ... shoot the gun.
        Shoot ();
    }
}



public function Shoot ()
{
    shootRay.origin = transform.position;
    shootRay.direction = transform.forward;

    if(Physics.Raycast (transform.position, transform.forward, shootHit, 50.0))
    {
     Instantiate(bullet,shootHit.point, Quaternion.LookRotation( shootHit.normal));
    }
}