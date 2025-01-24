using Godot;
using System;

public partial class Crab : CharacterBody2D
{
	public const float Speed = 100.0f;
	public const float Distance = 80;
	private GameManager gameManager;

	[Export]
	private Sprite2D normalSprite;
	[Export]
	private Sprite2D angrySprite;

	public override void _Ready()
	{
		gameManager = GameManager.Get(this);
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor())
		{
			velocity += GetGravity() * (float)delta;
		}

		Vector2 direction = gameManager.Player.Position - Position;
		bool isClose = direction.Length() < Distance;
		if (isClose) {
			angrySprite.Visible = true;
			normalSprite.Visible = false;
		} else {
			angrySprite.Visible = false;
			normalSprite.Visible = true;
		}

		if (isClose && Math.Abs(direction.X) > 10) {
			velocity.X = direction.X > 0 ? Speed : -Speed;
		} else if (!isClose) {
			velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed * (float)delta);
		}

		Velocity = velocity;
		MoveAndSlide();
	}
}
