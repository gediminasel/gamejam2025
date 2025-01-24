using Godot;
using System;

public partial class Player : CharacterBody2D
{
	public const float MaxVelocity = 100.0f;
	public const float Acceleration = 300.0f;
	public const float Friction = 0.3f;
	public const float FrictionThreshold = 30;
	public const float Friction2Delta = 100;

	[Export]
	public Node2D Sprite;

	private bool isDead = false;
	private StringName enemiesGroup = "Enemies";

	public override void _Ready()
	{
		GameManager.Get(this).Player = this;
	}

	public override void _PhysicsProcess(double delta)
	{
		if (isDead) {
			if (Position.Y < 0) {
				Velocity = Vector2.Zero;
				return;
			}
			Vector2 scale = Sprite.Scale;
			scale.Y = -1;
			Sprite.Scale = scale;
			MoveTo(new Vector2(0, -1), (float)delta);
			MoveAndSlide();
			return;
		}
		MoveTo(Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down"), (float)delta);
		MoveAndSlide();
		ClampPosition();

		for (int i = 0; i < GetSlideCollisionCount(); i++)
		{
			var collision = GetSlideCollision(i);
			var collider = collision.GetCollider();
			if (collider is Node node) {
				OnCollision(node);
			}
		}
	}

	private void MoveTo(Vector2 input, float delta) {
		if (input != Vector2.Zero)
		{
			Vector2 velocity = Velocity;
			velocity += input * Acceleration * delta;
			velocity.LimitLength(MaxVelocity);
			Velocity = velocity;
		} else {
			Vector2 velocity = Velocity;
			if (velocity.Length() > FrictionThreshold) {
				velocity *= (float)Math.Pow(Friction, delta);
			}
			else {
				velocity = velocity.LimitLength(Math.Max(0, velocity.Length() - Friction2Delta * delta));
			}
			Velocity = velocity;
		}
		
		if (Velocity.X > 0) {
			Sprite.Scale = new Vector2(1, 1);
		} else if (Velocity.X < 0) {
			Sprite.Scale = new Vector2(-1, 1);
		}
	}

	private void ClampPosition() {
		Vector2 position = Position;
		Vector2 velocity = Velocity;
		if (position.X < 0) {
			position.X = 0;
			if (velocity.X < 0) {
				velocity.X = 0;
			}
		}
		if (position.Y < 0) {
			position.Y = 0;
			if (velocity.Y < 0) {
				velocity.Y = 0;
			}
		}
		Position = position;
		Velocity = velocity;
	}

	private void OnCollision(Node node) {
		if (node.IsInGroup(enemiesGroup)) {
			Die();
		}
	}

	public void Die() {
		isDead = true;
		Velocity = new Vector2(0, -50);
		GetNode<CollisionShape2D>("CollisionShape2D").Disabled = true;
	}
}
