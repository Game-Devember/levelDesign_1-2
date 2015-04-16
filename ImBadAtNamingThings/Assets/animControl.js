#pragma strict

private var anim : Animator;
private var v : float;
private var aim: float;

function Start () {

anim = GetComponent("Animator");
anim.SetFloat("idleShoot",0);
}

function Update () {

	v = Input.GetAxis("Vertical");
	anim.SetFloat("Speed",v);
	if(Input.GetMouseButtonDown(0)) playIdle();
}

function playIdle()
{
	aim = 0.01;
	while(aim < 1)
	{
		anim.SetFloat("idleShoot",aim);
		yield WaitForSeconds(0.01);
		aim += 0.09;
	}
	anim.SetFloat("idleShoot",1);
	yield WaitForSeconds(0.3);
	while(aim > 0)
	{
		anim.SetFloat("idleShoot",aim);
		yield WaitForSeconds(0.01);
		aim -= 0.05;
	}
	anim.SetFloat("idleShoot",0);	
}