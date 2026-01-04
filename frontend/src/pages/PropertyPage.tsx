import { useEffect, useState } from "react";
import { useParams, Navigate } from "react-router-dom";
import { Navigation } from "@/components/navigation";
import { PropertyDetail } from "@/components/property-detail";
import { fetchPlaceById } from "@/api/places";

const MAX_AUTO_RETRIES = 2;
const RETRY_BASE_DELAY_MS = 1200;

export default function PropertyPage() {
  const { id } = useParams();
  const [property, setProperty] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [notFound, setNotFound] = useState(false);
  const [retryCount, setRetryCount] = useState(0);

  useEffect(() => {
    setRetryCount(0);
  }, [id]);

  useEffect(() => {
    if (!id) {
      setNotFound(true);
      setLoading(false);
      return;
    }

    let isMounted = true;
    setLoading(true);
    setError(null);
    setNotFound(false);

    fetchPlaceById(id, { force: retryCount > 0 })
      .then((data) => {
        if (!isMounted) return;
        if (!data) {
          setNotFound(true);
          return;
        }
        setProperty(data);
      })
      .catch((err) => {
        if (!isMounted) return;
        setError(err.message || "Unable to load property");
      })
      .finally(() => {
        if (isMounted) {
          setLoading(false);
        }
      });

    return () => {
      isMounted = false;
    };
  }, [id, retryCount]);

  useEffect(() => {
    if (!error || notFound) return;
    if (retryCount >= MAX_AUTO_RETRIES) return;

    const delay = RETRY_BASE_DELAY_MS * (retryCount + 1);
    const timer = setTimeout(() => {
      setRetryCount((count) => count + 1);
    }, delay);

    return () => clearTimeout(timer);
  }, [error, retryCount, notFound]);

  if (notFound) {
    return <Navigate to="/" replace />;
  }

  return (
    <div className="min-h-screen bg-white">
      <Navigation />
      {loading && (
        <div className="pt-40 text-center text-gray-500">Loading property...</div>
      )}
      {error && !loading && (
        <div className="pt-40 text-center text-red-600 space-y-3">
          <p>{error}</p>
          {retryCount < MAX_AUTO_RETRIES && (
            <p className="text-sm text-gray-500">Retrying now...</p>
          )}
          {retryCount >= MAX_AUTO_RETRIES && (
            <button
              onClick={() => {
                setRetryCount(0);
              }}
              className="text-sm text-black underline"
            >
              Try again
            </button>
          )}
        </div>
      )}
      {!loading && !error && property && <PropertyDetail property={property} />}
    </div>
  );
}
