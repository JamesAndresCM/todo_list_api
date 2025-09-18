import { useEffect, useRef, useState } from 'react';

export function useServerSentEvents() {
  const eventSourceRef = useRef<EventSource | null>(null);
  const [isConnected, setIsConnected] = useState(false);

  const connect = (onMessage: (event: string, payload: any) => void) => {
    if (eventSourceRef.current) return;

    const eventSource = new EventSource("http://localhost:4000/api/v1/events");

    eventSource.onopen = () => {
      console.log("SSE connection opened");
      setIsConnected(true);
    };

    eventSource.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        console.log("SSE message received:", data);
        
        if (data.type !== "connected" && data.type !== "keep-alive") {
          onMessage(data.type, data.payload);
        }
      } catch (error) {
        console.error("Error parsing SSE message:", error);
      }
    };

    eventSource.onerror = (error) => {
      console.error("SSE error:", error);
      setIsConnected(false);
    };

    eventSourceRef.current = eventSource;
  };

  const disconnect = () => {
    if (eventSourceRef.current) {
      eventSourceRef.current.close();
      eventSourceRef.current = null;
    }
    setIsConnected(false);
  };

  return {
    connect,
    disconnect,
    isConnected,
  };
}
