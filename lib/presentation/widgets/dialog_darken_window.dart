import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnimatedSuccessDialog extends StatefulWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final String? rejectButtonText;
  final VoidCallback? onRejectPressed;
  final IconData icon;
  final Color iconColor;
  final Color buttonColor;
  final Color rejectButtonColor; // New

  const AnimatedSuccessDialog({
    super.key,
    this.title = '¡Registro exitoso!',
    this.message = 'Revisa tu codigo de verificacion en tu correo electronico',
    this.buttonText = 'Continuar',
    this.onButtonPressed,
    this.rejectButtonText,
    this.onRejectPressed,
    this.icon = Icons.check_circle,
    this.iconColor = const Color(0xFF02066F),
    this.buttonColor = const Color(0xFF02066F),
    this.rejectButtonColor = Colors.red, // Default to red
  });

  @override
  State<AnimatedSuccessDialog> createState() => _AnimatedSuccessDialogState();
}

class _AnimatedSuccessDialogState extends State<AnimatedSuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(_fadeAnimation.value),
              ),
            ),
            ScaleTransition(
              scale: _scaleAnimation,
              child: Dialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: widget.iconColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.iconColor,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          if (widget.rejectButtonText != null)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  _controller.reverse().then((_) {
                                    if (widget.onRejectPressed != null) {
                                      widget.onRejectPressed!();
                                    }
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: widget.rejectButtonColor,
                                  side: BorderSide(color: widget.rejectButtonColor),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  widget.rejectButtonText!,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          if (widget.rejectButtonText != null)
                            const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _controller.reverse().then((_) {
                                  if (widget.onButtonPressed != null) {
                                    widget.onButtonPressed!();
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.buttonColor,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                widget.buttonText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}