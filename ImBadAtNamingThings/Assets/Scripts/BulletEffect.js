#pragma strict
var playerHealth=100;
private var anim : Animator ;
var deathHash : int = Animator.StringToHash("death");
var navAg : NavMeshAgent;

function Start () {

anim = GetComponent("Animator");
navAg = GetComponent("NavMeshAgent");

}

function Update () {
	if(playerHealth<=0)
	{
		deathWait();
	}
}

function TakeDamage()
 {
 	playerHealth-=50;
 }
 
 function deathWait()
 {
 	navAg.Stop();
 	gameObject.GetComponent(Collider).enabled=false;
 	anim.SetTrigger(deathHash);
 	yield WaitForSeconds(3);
 	Destroy(gameObject);
 }