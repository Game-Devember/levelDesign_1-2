private var shootRay : Ray;                                   
private var shootHit : RaycastHit; 
var player :Transform;                           
var bullet :Transform;
var shootSound : AudioClip;
var reloadSound : AudioClip;
private var soundClip : AudioSource;
var hitDistance =50.0;
var reload :boolean;
var muzzleFlash : Light;
//var shotVector :LineRenderer;
function Start()
 {
    //shotVector=GetComponent(LineRenderer);
 	soundClip = GetComponent.<AudioSource>();
  	reload=false;   
 }                 
function Update ()
{
   
    if(Input.GetMouseButtonDown(0)&&reload==false)
    {
        // ... shoot the gun.
        Shoot ();
       // audio.PlayOneShot(shellFalls,0.7);
            }
}



public function Shoot ()
 { // shotVector.enabled = true;
   // shotVector.SetPosition (0, transform.position);

   reload=true;
    if(Physics.Raycast (transform.position, transform.forward, shootHit,hitDistance))
    {
     //shotVector.SetPosition(0,shootHit.point);
     var enemyHealth  = shootHit.collider.GetComponent (BulletEffect);
      if(enemyHealth != null)
       {// ... the enemy should take damage.
            enemyHealth.TakeDamage ();
            
           
        }
        else
          {
           Instantiate(bullet,shootHit.point+(player.position-shootHit.point)*0.01 , Quaternion.LookRotation( shootHit.normal));
           //shotVector.SetPosition (1,shootHit.point);
           }
           
      }
      soundClip.clip = shootSound;
      soundClip.Play();
 	muzzleFlash.enabled=true;
 	yield WaitForSeconds(0.1);
 	muzzleFlash.enabled=false;
    yield WaitForSeconds(0.7);
    soundClip.clip = reloadSound;
    soundClip.Play();
    yield WaitForSeconds(0.2);
  	reload=false;
}




