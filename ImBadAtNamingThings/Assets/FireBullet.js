#pragma strict
var speed=20.0 ;
function Start () {
rigidbody.AddForce(transform.forward*speed);
}

function Update () {

}
function OnTriggerEnter(other : Collider)
 {
  if(other.gameObject.tag!="BulletSpawn")
     Destroy(gameObject);
     }