@extends('layout.template')

@section('main')
    <style>
        .prose {
            max-width: 100%;
        }

        .prose h1,
        .prose h2,
        .prose h3 {
            margin-top: 1em;
            margin-bottom: 0.5em;
            font-weight: bold;
        }

        .prose h1 {
            font-size: 1.5em;
        }

        .prose h2 {
            font-size: 1.3em;
        }

        .prose h3 {
            font-size: 1.1em;
        }

        .prose ul,
        .prose ol {
            padding-left: 1.5em;
            margin: 0.5em 0;
        }

        .prose li {
            margin: 0.25em 0;
        }

        .prose pre {
            background: #2d3748;
            color: white;
            padding: 1em;
            border-radius: 0.5em;
            overflow-x: auto;
        }

        .prose code {
            font-family: monospace;
        }
    </style>

    <div class="p-4">
        <!-- Edit API Key Section -->
        <div class="mb-8 p-4 bg-white rounded-lg shadow">
            <h1 class="text-2xl font-bold text-green-700 mb-4">Edit API Chatbot</h1>

            @if (session('success'))
                <div class="mb-4 p-3 bg-green-100 text-green-700 rounded">
                    {{ session('success') }}
                </div>
            @endif

            <form action="{{ route('chatbot.update-api') }}" method="POST">
                @csrf
                <div class="mb-4">
                    <label for="api_key" class="block text-sm font-medium text-gray-700 mb-1">API Key</label>
                    <input type="text" id="api_key" name="api_key" value="{{ $apikey ?? '' }}"
                        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-green-500 focus:border-green-500">
                    <p class="mt-1 text-sm text-gray-500">
                        Get your API key from <a href="https://openrouter.ai/settings/keys" target="_blank"
                            class="text-green-600 hover:underline">OpenRouter</a>
                    </p>
                </div>
                <button type="submit"
                    class="px-4 py-2 bg-green-600 text-white rounded-md hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-green-500">
                    Update API Key
                </button>
            </form>
        </div>

        <!-- Chatbot Section -->
        <div class="p-4 bg-white rounded-lg shadow">
            <div class="flex justify-between items-center mb-4">
                <h1 class="text-2xl font-bold text-green-700">Chatbot</h1>
                <div id="remaining-count" class="px-3 py-1 bg-green-100 text-green-800 rounded-full font-semibold">
                    Remaining: {{ $maxSendCount }}
                </div>
            </div>

            <div id="chat-container"
                class="border rounded-lg h-96 mb-4 p-4 overflow-y-auto bg-gray-50 flex flex-col space-y-3">
                <!-- Messages will appear here -->
            </div>

            <div class="flex gap-2 items-center">
                <input type="text" id="message-input" placeholder="Type your message..."
                    class="flex-1 px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                <button id="send-button"
                    class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 disabled:bg-gray-400">
                    Send
                </button>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const chatContainer = document.getElementById('chat-container');
            const messageInput = document.getElementById('message-input');
            const sendButton = document.getElementById('send-button');
            const remainingCount = document.getElementById('remaining-count');

            let sendCount = 0;
            const maxSendCount = {{ $maxSendCount }};

            function updateRemainingCount() {
                const remaining = maxSendCount - sendCount;
                remainingCount.textContent = `Remaining: ${remaining}`;

                if (remaining <= 0) {
                    remainingCount.classList.remove('bg-green-100', 'text-green-800');
                    remainingCount.classList.add('bg-red-100', 'text-red-800');
                    messageInput.disabled = true;
                    sendButton.disabled = true;
                } else {
                    remainingCount.classList.remove('bg-red-100', 'text-red-800');
                    remainingCount.classList.add('bg-green-100', 'text-green-800');
                    messageInput.disabled = false;
                    sendButton.disabled = false;
                }
            }

            function addMessage(text, isUser) {
                const messageDiv = document.createElement('div');
                messageDiv.className = `flex ${isUser ? 'justify-end' : 'justify-start'}`;

                const bubble = document.createElement('div');
                bubble.className = `max-w-3/4 rounded-lg p-3 prose ${
                    isUser
                        ? 'bg-green-100 rounded-tr-none'
                        : 'bg-gray-200 rounded-tl-none'
                }`;

                // Enhanced markdown support with better regex
                let formattedText = text
                    // Headers (handle multiple # properly)
                    .replace(/^#{1,6}\s+(.*$)/gm, function(match, p1) {
                        const level = match.match(/^#+/)[0].length;
                        return `<h${level} class="text-${['xl','lg','md','base','sm','xs'][level-1]} font-bold my-2">${p1}</h${level}>`;
                    })
                    // Lists (improved handling)
                    .replace(/^(\d+\.|\-|\+)\s+(.*$)/gm, function(match) {
                        const type = match.startsWith('-') || match.startsWith('+') ? 'disc' : 'decimal';
                        return `<li class="ml-4 list-${type}">${match.replace(/^(\d+\.|\-|\+)\s+/, '')}</li>`;
                    })
                    // Bold and italic (handle multi-line)
                    .replace(/\*\*([\s\S]+?)\*\*/g, '<strong class="font-bold">$1</strong>')
                    .replace(/\*([\s\S]+?)\*/g, '<em class="italic">$1</em>')
                    // Code (handle inline and blocks better)
                    .replace(/`{3}([\s\S]+?)`{3}/g,
                        '<pre class="bg-gray-800 text-white p-3 rounded overflow-x-auto my-2"><code>$1</code></pre>'
                    )
                    .replace(/`([^`]+)`/g, '<code class="bg-gray-300 px-1 rounded font-mono">$1</code>')
                // Horizontal rules
                .replace(/^---+/gm, '<hr class="my-3 border-gray-300">')
                // Paragraphs and line breaks
                .replace(/\n\n+/g, '</p><p class="my-2">')
                .replace(/\n/g, '<br>');

            // Ensure proper HTML structure
            if (!formattedText.includes('<') || formattedText.startsWith('<br>')) {
                formattedText = `<div class="prose">${formattedText}</div>`;
            }

            bubble.innerHTML = formattedText;
            messageDiv.appendChild(bubble);
            chatContainer.appendChild(messageDiv);
            chatContainer.scrollTop = chatContainer.scrollHeight;
        }

        async function sendMessage() {
            const message = messageInput.value.trim();
            if (!message || sendCount >= maxSendCount) return;

            addMessage(message, true);
            messageInput.value = '';
            sendButton.disabled = true;

            try {
                const response = await fetch('{{ route('chatbot.chat') }}', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json',
                        'X-CSRF-TOKEN': '{{ csrf_token() }}'
                    },
                    body: JSON.stringify({
                        message: message,
                        sendCount: sendCount,
                        maxSendCount: maxSendCount
                    })
                });

                const data = await response.json();

                if (!response.ok) {
                    throw new Error(data.error || 'Network response was not ok');
                }

                if (data.error) {
                    addMessage(`Error: ${data.error}`, false);
                } else {
                    addMessage(data.reply, false);
                    // Update count based on server response
                    sendCount = data.sendCount || (maxSendCount - data.remaining);
                    updateRemainingCount();
                }
            } catch (error) {
                addMessage(`Error: ${error.message}`, false);
                    console.error('Chat Error:', error);
                } finally {
                    sendButton.disabled = false;
                }
            }

            // Event listeners
            sendButton.addEventListener('click', sendMessage);
            messageInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    sendMessage();
                }
            });

            // Initialize remaining count
            updateRemainingCount();
        });
    </script>
@endsection
