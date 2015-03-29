#pragma strict
var playerHealth=100;
var anim : Animator ;
var deathHash : int = Animator.StringToHash("death");
var navAg : NavMeshAgent;

function Start () {

anim = GetComponent("Animator");
navAg = GetComponent("NavMeshAgent");

}

function Update () {
	if(playerHealth<=0)
	{
		anim.SetTrigger(deathHash);
		deathWait();
	}
}

function TakeDamage()
 {
 	playerHealth-=50;
 }
 
 function deathWait()
 {
 	navAg.enabled = false;
 	yield WaitForSeconds(3);
 	Destroy(gameObject);
 }